//
//  Created by Ramesh Kumar on 1/29/20.
//

import LiteNode

do {
    let tree = try HTML("<h1>RAMESH KUMAR</h1>")
    print(tree.description)
}
catch {
    print("Error: \(error)")
}
