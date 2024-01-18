// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-nocheck
// eslint-disable @typescript-eslint/no-unused-vars
//
// Automatically generated by
//     ____________ 
//    / __/_  __/ / 
//   / _/  / / / /__
//  /_/   /_/ /____/            
//
//
import * as currency from "./currency"
export interface ListRequest {
}

export interface Product {
  id: string;
  name: string;
  description: string;
  picture: string;
  priceUSD: currency.Money;
  categories: string[];
}

export interface ListResponse {
  products: Product[];
}

export interface GetRequest {
  id: string;
}

export interface SearchRequest {
  query: string;
}

export interface SearchResponse {
  results: Product[];
}


export class ProductcatalogClient {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  public async list(request: ListRequest): Promise<ListResponse> {
    const path = `/productcatalog?@json=${encodeURIComponent(JSON.stringify(request))}`;
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (!response.ok) {
      throw new Error(`Error: ${response.status}`);
    }

    return response.json();
  }

  public async get(request: GetRequest): Promise<Product> {
    const path = `/productcatalog/id?@json=${encodeURIComponent(JSON.stringify(request))}`;
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (!response.ok) {
      throw new Error(`Error: ${response.status}`);
    }

    return response.json();
  }
}
