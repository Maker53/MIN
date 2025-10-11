//  Created by Stanislav Shalgin on 04.10.2025.

import UIKit
import SnapKit

public protocol DisplaysRegistrationView: UIView { }

@MainActor
public protocol RegistrationViewDelegate: AnyObject {
    func textFieldDidChange(_ textFieldInput: AuthDataFlow.TextFieldInput)
    func registerButtonDidTapped()
}

public final class RegistrationView: UIView {
    // MARK: Views
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let headerIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill.badge.plus"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте аккаунт — введите свою почту и придумайте надёжный пароль."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Почта",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 20, weight: .light)
            ]
        )
        return textField
    }()
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .next
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 20, weight: .light)
            ]
        )
        return textField
    }()
    
    private let separatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Повторите пароль",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 20, weight: .light)
            ]
        )
        return textField
    }()
    
    private let separatorView4: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    private let swipeToLoginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        let fullText = "Уже есть аккаунт? Войти"
        let attributedText = NSMutableAttributedString(string: fullText)

        let grayAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]

        let blueAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]

        attributedText.addAttributes(grayAttrs, range: NSRange(location: 0, length: 18))
        attributedText.addAttributes(blueAttrs, range: (fullText as NSString).range(of: "Войти"))

        label.attributedText = attributedText
        label.isUserInteractionEnabled = true

        return label
    }()
    
    private let registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.titleAlignment = .center
        config.buttonSize = .large
        
        config.attributedTitle = AttributedString("Зарегистрироваться", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]))

        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.configurationUpdateHandler = { btn in
            if btn.isHighlighted {
                btn.configuration?.baseBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
            } else {
                btn.configuration?.baseBackgroundColor = .systemBlue
            }
        }

        return button
    }()
    
    // MARK: Properties
    
    weak var delegate: RegistrationViewDelegate?
    
    // MARK: Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupGesture()
        
        backgroundColor = .systemBackground
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        registerButton.addTarget(self, action: #selector(registerButtonDidTapped), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: DisplaysRegistrationView

extension RegistrationView: DisplaysRegistrationView { }

// MARK: UITextFieldDelegate

extension RegistrationView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
            registerButtonDidTapped()
        default:
            break
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            delegate?.textFieldDidChange(.email(textField.text))
        case passwordTextField:
            delegate?.textFieldDidChange(.password(textField.text))
        case repeatPasswordTextField:
            delegate?.textFieldDidChange(.repeatPassword(textField.text))
        default:
            break
        }
    }
}

// MARK: Actions

private extension RegistrationView {
    @objc
    func registerButtonDidTapped() {
        delegate?.registerButtonDidTapped()
    }

    @objc
    func dismissKeyboard() {
        endEditing(true)
    }
}


// MARK: Private

private extension RegistrationView {
    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(separatorView1)
        contentView.addSubview(emailTextField)
        contentView.addSubview(separatorView2)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(separatorView3)
        contentView.addSubview(repeatPasswordTextField)
        contentView.addSubview(separatorView4)
        addSubview(swipeToLoginLabel)
        addSubview(registerButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        headerIcon.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(headerIcon.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        separatorView1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(separatorView1.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(36)
        }
        
        separatorView2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(separatorView2.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(36)
        }
        
        separatorView3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        repeatPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(separatorView3.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(36)
        }
        
        separatorView4.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(repeatPasswordTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        swipeToLoginLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
        }
        
        registerButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.top.equalTo(swipeToLoginLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
}
