Ti starai chiedendo: "perché abbiamo bisogno di un altro proxy quando abbiamo già due server che fanno poco?"
La risposta è semplice e deriva da questo fattori:
- OPA non riesce a fare da solo il parsing delle richieste HTTP. Questo vuol dire che non ha primitive per analizzare gli header, né il body o altro. In qualche modo, un proxy glielo deve parsare.

La domanda dopo allora sorge spontanea: "perché non usare il revproxy fatto con nginx, che ha il supporto per JS e quindi per la creazione di un sistema di parsing?". 
Anche a questo la risposta è semplice. Considera che nel nostro revproxy usiamo la direttiva `auth_request` che praticamente ci toglie con forza bruta alcune cose, in particolare:
- trasforma la richiesta HTTP in una GET, a prescidere che sia post o altro
- ... di conseguenza il body viene totalmente scartato e buttato via. This sucks.
- Perché non mandare allora le informazioni tramite una query? Bene, auth_request non permette l'uso delle variabili, quindi l'uri originale viene malamente ignorato. Inoltre, impedisce l'inserimento di header personalizzati. 


In poche parole, tutto questo deriva dal fatto che la direttiva auth_request di nginx è fatta molto male e non ho capito perché si sono svolte queste dubbiose scelte implementative, che ci spingono a fare uso di sistemi molto meno sicuri. Ma vabbe...
