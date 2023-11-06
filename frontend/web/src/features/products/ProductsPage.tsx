import { useEffect, useState } from 'react'
import { Product, ProductcatalogClient } from '../../api/productcatalog'

export const ProductsPage = () => {
  const [products, setProducts] = useState<Product[]>([])

  useEffect(() => {
    const productsClient = new ProductcatalogClient('http://localhost:8892/ingress')
    productsClient.list({}).then((response) => setProducts(response.products || []))
  }, [])

  return (
    <div className='p-4'>
      <h1 className='text-3xl font-bold underline'>Products</h1>
      <ul className='py-2'>
        {products.map((product) => (
          <li key={product.id}>{product.name}</li>
        ))}
      </ul>
    </div>
  )
}
