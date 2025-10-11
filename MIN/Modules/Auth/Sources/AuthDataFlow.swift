//  Created by Stanislav Shalgin on 11.10.2025.

@frozen
public enum AuthDataFlow {
    enum Registration {
        enum UserInput {
            typealias Request = TextFieldInput
        }
    }
    
    @frozen
    public enum TextFieldInput {
        case email(String?)
        case password(String?)
        case repeatPassword(String?)
    }
}
