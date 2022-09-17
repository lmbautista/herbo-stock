#

![herbo-stock](https://user-images.githubusercontent.com/6224703/173449457-35e9032b-29f8-40bf-b748-8b9488cd08cb.png)

🛍 Shopify application for *HerbaMadrid* store 🌿

## Summary

Ruby on Rails application to manage **Shopify** store´s stock.

## Introduction

`Herbo-stock` provides a list of features through the fulfillment service `Distribudiet` to keep a **Shopify** store up-to-date.

<details>
  <summary>📸 Application UI </summary>
  <img src="https://user-images.githubusercontent.com/6224703/190868290-719d0efa-4831-4c16-a83f-ec40eec3843b.png"/>
</details>

## How it works

### Catalog management

We allow to load the fulfillment service remote catalog from a shared `CSV` to **Shopify**. Here a hightlight of how the process works under the hood:

* It generates the product in the app to keep the original format
* It parses the original product into a **Shopify** product with the required format. Then we  *creates/updates* in the **Shopify** store.

It has two running modes:

* `Manual`: we can either load the whole catalog or filtered by SKU.
* `Scheduled`: we can load the whole catalog based on a scheduler based on minutes, hours or days.

### Shopify catalog synchronization

We keep up-to-date each product of the catalog through the following **Shopify** work-flows:

* **Shopify** requests by default for an availability update each hour where all the products are updated. The request is done agains an specific endpoint.
* **Shopify** communicates once a fulfillment order is created (once an order is processed and archived). Then, the application updates the product in **Shopify** and the app itself. The request is done through a webhook

## Additional features

* All the actions are internally audited to keep tracking of them.
* Once a product got no availability, we temporarilly mark it as `archived`.
* Once the application is uninstalled, a webhook will manage the cleaning-up of the affected shop internally.
