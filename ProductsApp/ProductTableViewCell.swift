import UIKit

// MARK: - Custom Table View Cell
class ProductTableViewCell: UITableViewCell {
    static let identifier = "ProductTableViewCell"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemBlue
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor)
        ])
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        categoryLabel.text = product.category.uppercased()
        priceLabel.text = String(format: "$%.2f", product.price)
        ratingLabel.text = "★ \(product.rating.rate) (\(product.rating.count))"
        
        // Load image
        loadImage(from: product.image)
    }
    
    private func loadImage(from urlString: String) {
        productImageView.image = UIImage(systemName: "photo")
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            productImageView.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            productImageView.image = UIImage(systemName: "photo.fill")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.productImageView.image = UIImage(systemName: "photo.fill")
                }
                return
            }
            
            ImageCache.shared.setImage(image, forKey: urlString)
            
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo")
    }
}
