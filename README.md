#Search Twitter#

App para buscar a usuarios de twitter que tengan activada la localización en sus tweets.

##Descripción##

Esta hecha con swift, fabric y la api de twitter.

Uso SwiftyJSON para manejar las respuestas de tipo json ya que sin esta libreria es horrible manejar json en swift, recomiendo que la vean.

##Uso##

Necesitan crear una app de [twitter](https://apps.twitter.com)
con la siguiente configuración:

- Access level: Read and write
- Sign in with Twitter:	Yes

Despues crear un nuevo archivo tipo swift(vacio) llamado TwitterData.swift (el nombre puede ser el que ustedes quieran)
que tenga el siguiente codigo:
```
import Foundation

struct TwitterData {
    let consumerKey: String = "Consumer Key (API Key)"
    let secretKey: String = "Consumer Secret (API Secret)"
    static let newTwitterData = TwitterData()
}
```

Donde Consumer Secret (API Secret) y Consumer Secret (API Secret) son las keys que te da twitter al crear una nueva app.

No me hago responsable del mal uso de la app, es solo para pruebas y ver como es posible localizar usuarios de twitter que comparten su ubicación en la red social.

##Licencia##

[MIT License](http://opensource.org/licenses/MIT)