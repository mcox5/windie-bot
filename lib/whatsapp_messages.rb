module WhatsappMessages
  MESSAGES = {
    REGISTRATION: {
      ASK_ALIAS: "Hola soy Windie🤖! Tu nuevo asistente para leer el reporte del mar 🌊\n\nPara empezar, ¿cómo quieres que te llame?",
      SHOW_WINDIE_FEATURES: "Genial! Ya estamos listos con el registro 👌🏼!\nAhora te voy a contar un poco sobre cómo funciona *Windie*.\n\n
Me puedes *preguntar lo que quieras* relacionado al reporte de las olas 😯, ya sea el del mismo día, o dentro de las próximas dos semanas.\n
*Ejemplo*: Cómo estarán la olas en Pichilemu el viernes? o Cómo estará el viento en Topocalma el sábado?\n\n
⏰ Puedes *programarme* para que todas las mañanas te diga las condiciones del oleaje y mareas\n
*Ejemplo*: Mándame un mensaje a las 7AM todos los días con el reporte de la ola de Pichilemu:\n\n
🚨 Puedes *dejar programadas alertas* de cuando vengan *buenas olas* en las próximas semanas, para que puedas organizar con calma tu próximo viaje!\n
*Ejemplo*: Avísame cuando vengan olas de más de 2 metros a Matanzas en los próximos 15 días\n\n
Espero que te guste Windie🤖🌊💨! Cualquier duda o sugerencia, escríbeme a mi mail windie.chile@gmail.com o a mi WhatsApp: +56990168398\n\n
Si Windie te es útil, puedes ayudarme a seguir mejorando compartiéndolo con tus amigos 🙏🏼\n\n"
    }
  }

  def self.message(message_category, message_name)
    MESSAGES.dig(message_category, message_name)
  end
end
