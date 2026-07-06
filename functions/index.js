const {GoogleGenerativeAI} = require("@google/generative-ai");
const admin = require("firebase-admin");
const {setGlobalOptions} = require("firebase-functions/v2");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret, defineString} = require("firebase-functions/params");
const sendgrid = require("@sendgrid/mail");
const Stripe = require("stripe");

admin.initializeApp();
setGlobalOptions({region: "us-central1", maxInstances: 10});

const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");
const sendgridApiKey = defineSecret("SENDGRID_API_KEY");
const geminiApiKey = defineSecret("GEMINI_API_KEY");
const sendgridFromEmail = defineString("SENDGRID_FROM_EMAIL", {
  default: "ventas@lacasona.com",
});
const sendgridFromName = defineString("SENDGRID_FROM_NAME", {
  default: "La Casona",
});

exports.createPaymentIntent = onCall(
  {secrets: [stripeSecretKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Inicia sesion para pagar.");
    }

    const amount = Number(request.data?.amount);
    const currency = String(request.data?.currency || "usd").toLowerCase();

    if (!Number.isFinite(amount) || amount <= 0) {
      throw new HttpsError("invalid-argument", "Monto de pago invalido.");
    }

    const amountInCents = Math.round(amount * 100);
    const stripe = new Stripe(stripeSecretKey.value(), {
      apiVersion: "2025-06-30.basil",
    });

    try {
      const intent = await stripe.paymentIntents.create({
        amount: amountInCents,
        currency,
        payment_method_types: ["card"],
        metadata: {
          userId: request.auth.uid,
          app: "La Casona",
          mode: "test",
        },
      });

      return {
        id: intent.id,
        amount: intent.amount,
        currency: intent.currency,
        status: intent.status,
        client_secret: intent.client_secret,
      };
    } catch (error) {
      console.error("Stripe PaymentIntent error", error);
      throw new HttpsError("internal", "No se pudo iniciar el pago.");
    }
  },
);

exports.sendPurchaseEmail = onCall(
  {secrets: [sendgridApiKey]},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Inicia sesion para enviar correo.");
    }

    const destinatario = String(request.data?.destinatario || "").trim();
    const asunto = String(request.data?.asunto || "").trim();
    const contenido = String(request.data?.contenido || "").trim();

    if (!destinatario || !asunto || !contenido) {
      throw new HttpsError("invalid-argument", "Datos de correo incompletos.");
    }

    sendgrid.setApiKey(sendgridApiKey.value());

    try {
      await sendgrid.send({
        to: destinatario,
        from: {
          email: sendgridFromEmail.value(),
          name: sendgridFromName.value(),
        },
        subject: asunto,
        html: contenido,
      });

      return {ok: true};
    } catch (error) {
      console.error("SendGrid email error", {
        code: error.code,
        message: error.message,
        response: error.response?.body,
        from: sendgridFromEmail.value(),
        to: destinatario,
      });
      throw new HttpsError(
        "failed-precondition",
        "No se pudo enviar el correo de confirmacion.",
      );
    }
  },
);

exports.generateChatReply = onCall(
  {secrets: [geminiApiKey]},
  async (request) => {
    const userMessage = String(request.data?.message || "").trim();
    const inventory = Array.isArray(request.data?.inventory) ?
      request.data.inventory.slice(0, 40).map((item) => String(item)) :
      [];

    if (!userMessage) {
      throw new HttpsError("invalid-argument", "Mensaje vacio.");
    }

    const model = new GoogleGenerativeAI(geminiApiKey.value())
      .getGenerativeModel({model: "gemini-2.5-flash"});

    const prompt = [
      "Eres Casona AI, asistente de moda de La Casona.",
      "Responde en espanol, con tono amable, moderno y breve.",
      "No saludes de forma larga si el usuario solo dice hola.",
      "No inventes productos, categorias, materiales, colecciones, descuentos ni stock.",
      "Solo puedes recomendar prendas que aparezcan en el inventario disponible.",
      "Si el usuario pide algo que no existe en el inventario, dilo claramente y ofrece 1 o 2 alternativas reales.",
      "Si recomiendas outfits, arma combinaciones usando nombres exactos de productos reales.",
      "Maximo 4 lineas salvo que el usuario pida mas detalle.",
      "",
      "Inventario disponible:",
      inventory.length ? inventory.join("\n") : "No hay inventario disponible.",
      "",
      `Usuario: ${userMessage}`,
      "Respuesta:",
    ].join("\n");

    try {
      const result = await model.generateContent(prompt);
      return {
        reply: result.response.text() || "No pude responder en este momento.",
      };
    } catch (error) {
      throw new HttpsError("internal", "No pude conectar con Casona AI.");
    }
  },
);
