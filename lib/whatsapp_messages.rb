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
Si Windie te es útil, puedes ayudarme a seguir mejorando compartiéndolo con tus amigos 🙏🏼\n\n",
      SHOW_WINDIE_FEATURES_BETA: "Genial! Ya estamos listos con el registro 👌🏼!\n\n
⏰Todas las mañanas te llegará el *reporte diario* del spot que elegiste al registrarte!\n\n
Ahora te voy a contar un poco sobre cómo puedes interactuar con *Windie*.\n\n
Si quieres saber cómo estará el mar en tu spot favorito, puedes escribir los siguientes comandos\n\n
*reporte de hoy*\n
*reporte de mañana*\n
*reporte de mareas hoy*\n
*reporte de mareas mañana*\n
*olas grandes en la proxima semana*\n\n

Esta versión de Windie es una *versión beta* 🐣\n
Próximamente tendrás las siguientes features disponibles:\n\n
⏰ *Programar reportes diarios* para que te lleguen a la hora que quieras\n
🚨 *Alertas de olas grandes* para que te avise cuando vengan buenas olas a tu spot favorito\n
🌊 Poder consultar las condiciones de *cualquier spot* del mundo!\n
🤖 *Windie IA* vas a poder entrenar e interactuar con windie con lenguaje natural y *NO* con comandos\n
Es decir le podrás dar instrucciones para que te de alertas para condiciones específicas de cada spot o lo que se te ocurra!\n\n
Espero que te guste Windie🤖🌊💨! Cualquier duda/sugerencia/feedback, escríbeme\n📪 *mail* windie.chile@gmail.com\n✆ *WhatsApp* *+56990168398*"
    },
    CONVERSATION: {
      ERROR: "Lo siento, aún no estoy programado para responder ese tipo de mensajes 😕. Por favor, intenta de nuevo con uno de los comandos que te dije en el mensaje de bienvenida!",
    }
  }

  def self.message(message_category, message_name)
    MESSAGES.dig(message_category, message_name)
  end
end
