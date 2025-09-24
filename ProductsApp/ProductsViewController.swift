import UIKit

// MARK: - Main View Controller
class ProductsViewController: UIViewController {
    private let networkService: NetworkServiceProtocol = NetworkService()
    private var products: [Product] = []
    private var currentPage = 0
    private var isLoading = false
    private var hasMorePages = true
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        return tableView
    }()
    
    private let loadingView = LoadingView()
    private let errorView = ErrorView()
    private let emptyStateView = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "Products"
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        // Setup state views
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        view.addSubview(errorView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        errorView.onRetry = { [weak self] in
            self?.retryLoading()
        }
        
        hideAllStateViews()
    }
    
    private func hideAllStateViews() {
        loadingView.isHidden = true
        errorView.isHidden = true
        emptyStateView.isHidden = true
        tableView.isHidden = false
    }
    
    private func showLoadingState() {
        loadingView.isHidden = false
        errorView.isHidden = true
        emptyStateView.isHidden = true
        tableView.isHidden = true
    }
    
    private func showErrorState(message: String) {
        loadingView.isHidden = true
        errorView.isHidden = false
        emptyStateView.isHidden = true
        tableView.isHidden = true
        errorView.configure(with: message)
    }
    
    private func showEmptyState() {
        loadingView.isHidden = true
        errorView.isHidden = true
        emptyStateView.isHidden = false
        tableView.isHidden = true
    }
    
    private func showTableView() {
        hideAllStateViews()
    }
    
    private func loadProducts() {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        
        // Show loading state only for first page
        if currentPage == 0 {
            showLoadingState()
        }
        
        networkService.fetchProducts(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    if self?.currentPage == 0 {
                        self?.products = response.data
                    } else {
                        self?.products.append(contentsOf: response.data)
                    }
                    
                    // Check if there are more pages
                    let totalPages = Int(ceil(Double(response.pagination.total) / Double(response.pagination.limit)))
                    self?.hasMorePages = (response.pagination.page + 1) < totalPages
                    
                    if self?.products.isEmpty == true {
                        self?.showEmptyState()
                    } else {
                        self?.showTableView()
                        self?.tableView.reloadData()
                    }
                    
                    self?.currentPage += 1
                    
                case .failure(let error):
                    if self?.currentPage == 0 {
                        // Show error state only if no products are loaded
                        if let networkError = error as? NetworkService.NetworkError {
                            self?.showErrorState(message: networkError.localizedDescription)
                        } else {
                            self?.showErrorState(message: error.localizedDescription)
                        }
                    } else {
                        // Show alert for pagination errors
                        self?.showAlert(message: "Failed to load more products")
                    }
                }
            }
        }
    }
    
    private func retryLoading() {
        currentPage = 0
        hasMorePages = true
        products.removeAll()
        loadProducts()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
}

// MARK: - TableView Delegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product = products[indexPath.row]
        let detailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more data when reaching the last few cells
        if indexPath.row >= products.count - 3 {
            loadProducts()
        }
    }
}
