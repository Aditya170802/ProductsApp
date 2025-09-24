import UIKit


class ProductDetailViewController: UIViewController {
    private let product: Product
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.systemGray5
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let specsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithProduct()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "Product Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(specsStackView)
        contentView.addSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 200),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            brandLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ratingLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            specsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            specsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            specsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            stockLabel.topAnchor.constraint(equalTo: specsStackView.bottomAnchor, constant: 16),
            stockLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureWithProduct() {
        titleLabel.text = product.title
        brandLabel.text = product.brand
        priceLabel.text = String(format: "$%.2f", product.price)
        ratingLabel.text = "★ \(product.rating.rate) (\(product.rating.count) reviews)"
        descriptionLabel.text = product.description
        stockLabel.text = "Stock: \(product.stock) available"
        
        // Configure specs - safely handle optional properties
        let specs = product.specs
        if let color = specs.color, !color.isEmpty {
            addSpecRow(title: "Color", value: color)
        }
        if let weight = specs.weight {
            addSpecRow(title: "Weight", value: weight)
        }
        if let storage = specs.storage {
            addSpecRow(title: "Storage", value: storage)
        }
        if let battery = specs.battery {
            addSpecRow(title: "Battery", value: battery)
        }
        if let screen = specs.screen {
            addSpecRow(title: "Screen", value: screen)
        }
        if let ram = specs.ram {
            addSpecRow(title: "RAM", value: ram)
        }
        if let capacity = specs.capacity {
            addSpecRow(title: "Capacity", value: capacity)
        }
        if let output = specs.output {
            addSpecRow(title: "Output", value: output)
        }
        if let connection = specs.connection {
            addSpecRow(title: "Connection", value: connection)
        }
        if let waterproof = specs.waterproof {
            addSpecRow(title: "Waterproof", value: waterproof ? "Yes" : "No")
        }
        
        
        loadImage()
    }
    
    private func addSpecRow(title: String, value: String) {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = UIColor.secondaryLabel
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        specsStackView.addArrangedSubview(containerView)
    }
    
    private func loadImage() {
        
        if let cachedImage = ImageCache.shared.getImage(forKey: product.image) {
            productImageView.image = cachedImage
            return
        }
        
        guard let url = URL(string: product.image) else {
            productImageView.image = UIImage(systemName: "photo")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.productImageView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            ImageCache.shared.setImage(image, forKey: self?.product.image ?? "")
            
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }.resume()
    }
}
