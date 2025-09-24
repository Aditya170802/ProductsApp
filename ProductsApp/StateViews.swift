import UIKit

// MARK: - Loading View
class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        addSubview(activityIndicator)
        addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16)
        ])
        
        activityIndicator.startAnimating()
    }
}

// MARK: - Error View
class ErrorView: UIView {
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.tintColor = UIColor.systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        addSubview(errorImageView)
        addSubview(errorLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            errorImageView.widthAnchor.constraint(equalToConstant: 60),
            errorImageView.heightAnchor.constraint(equalToConstant: 60),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
    
    func configure(with message: String) {
        errorLabel.text = message
    }
}

// MARK: - Empty State View
class EmptyStateView: UIView {
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tray.fill")
        imageView.tintColor = UIColor.systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No products available"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        addSubview(emptyImageView)
        addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            emptyImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16)
        ])
    }
}
