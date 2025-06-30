// Fetch payment modes from backend
fetch('/get_payment_modes')
    .then(response => response.json())
    .then(data => {
        const paymentModeSelect = document.getElementById('paymentMode');
        data.paymentModes.forEach(mode => {
            const option = document.createElement('option');
            option.value = mode.payment_mode_id;
            option.textContent = mode.mode_of_payment;
            paymentModeSelect.appendChild(option);
        });
    });


    function donePayment() {
        // Refresh the page when the button is clicked
        window.location.reload();
    }
// Update live time every second
setInterval(function () {
    const currentTime = new Date().toLocaleTimeString();
    document.getElementById('currentTime').textContent = currentTime;
}, 1000);

let selectedProductId = '';
let selectedProductName = '';
let selectedProductPrice = 0;
let selectedProductOfferId = '';
let selectedProductOfferDetails = '';
let productsInCart = [];

// Define customer type discounts
const customerTypeDiscounts = {
    'CT00S': 5,   // Silver Shopper: 5% discount
    'CT00G': 10,  // Gold Member: 10% discount
    'CT00P': 15,  // Platinum Patron: 15% discount
    'CT0PR': 20,  // Premium Patron: 20% discount
    'CT1BR': 5,   // Bargain Hunter: 5% discount
    'CT1EX': 10,  // Exclusive Elite: 10% discount
    'CT1VIP': 15, // VIP Shopper: 15% discount
    'CT1FAM': 5,  // Family Club: 5% discount
    'CT1DEL': 10, // Delivery Pro: 10% discount
    'CT1REW': 5   // Rewards Seeker: 5% discount
};


// Function to handle customer name input and show suggestions
function fetchCustomerSuggestions() {
    const customerName = document.getElementById('customer-name').value;
    if (customerName.length > 0) {
        $.ajax({
            url: '/suggest_customers',
            type: 'GET',
            data: { name: customerName },
            success: function(response) {
                const suggestions = response.customers || [];
                let suggestionsHtml = '';
                if (suggestions.length > 0) {
                    suggestions.forEach(customer => {
                        suggestionsHtml += `<div class="suggestion" onclick="selectCustomer('${customer.customer_id}', '${customer.customer_name}', '${customer.customer_type}')">
                            ${customer.customer_name} - ${customer.customer_type}
                        </div>`;
                    });
                } else {
                    suggestionsHtml = '<div class="suggestion">No customers found</div>';
                    document.getElementById('new-customer-btn').style.display = 'inline-block'; 
                }
                document.getElementById('customer-suggestions').innerHTML = suggestionsHtml;
            }
        });
    } else {
        document.getElementById('customer-suggestions').innerHTML = '';
        document.getElementById('new-customer-btn').style.display = 'none';
    }
}

// Function to show the "Add New Customer" form
function showNewCustomerForm() {
    document.getElementById('new-customer-form').style.display = 'block'; // Show the form
    document.getElementById('new-customer-btn').style.display = 'none'; // Hide the "Add New Customer" button after form shows
}


// Function to select a customer
function selectCustomer(customerId, customerName, customerType) {
    document.getElementById('customer-name').value = customerName;
    document.getElementById('customer-type').value = customerType;
    document.getElementById('customer-suggestions').innerHTML = '';
    document.getElementById('new-customer-btn').style.display = 'none';
}

// Fetch product suggestions
function fetchProductSuggestions() {
    const productName = document.getElementById('product-name').value;
    if (productName.length > 0) {
        $.ajax({
            url: '/suggest_products',
            type: 'GET',
            data: { name: productName },
            success: function(response) {
                const suggestions = response.products || [];
                let suggestionsHtml = '';
                if (suggestions.length > 0) {
                    suggestions.forEach(product => {
                        suggestionsHtml += `<div class="suggestion" onclick="selectProduct('${product.product_id}', '${product.name}', ${product.selling_price}, '${product.offer_id}', '${product.offers_details}')">
                            ${product.name} - ₹${product.selling_price}
                        </div>`;
                    });
                } else {
                    suggestionsHtml = '<div class="suggestion">No products found</div>';
                }
                document.getElementById('product-suggestions').innerHTML = suggestionsHtml;
            }
    });
} else {
        document.getElementById('product-suggestions').innerHTML = '';
    }
}

// Select product and set price
function selectProduct(productId, productName, sellingPrice, offerId, offerDetails) {
    document.getElementById('product-name').value = productName;
    document.getElementById('price').value = sellingPrice;
    selectedProductId = productId;
    selectedProductName = productName;
    selectedProductPrice = sellingPrice;
    selectedProductOfferId = offerId;
    selectedProductOfferDetails = offerDetails;
    document.getElementById('product-suggestions').innerHTML = '';
}

// Update price based on quantity
function updatePrice() {
    const quantity = document.getElementById('quantity').value;
    const totalPrice = selectedProductPrice * quantity;
    document.getElementById('price').value = totalPrice;
}

// Add product to cart
function addProductToTable() {
    const quantity = parseInt(document.getElementById('quantity').value);
    const measurement = document.getElementById('measurement').value;

    if (!selectedProductId || !selectedProductName || isNaN(selectedProductPrice)) {
        console.error("Product not selected or price is invalid.");
        return;
    }

    let discount = calculateDiscount(selectedProductOfferId, selectedProductPrice);
    const total = (selectedProductPrice - discount) * quantity;

    productsInCart.push({
        product_id: selectedProductId,
        product_name: selectedProductName,
        weight: `${quantity} ${measurement}`,
        price: selectedProductPrice,
        offer_id: selectedProductOfferId,
        offer_details: selectedProductOfferDetails,
        discount: discount,
        total: total
    });

    refreshProductTable();
    updateTotalBill();

    document.getElementById('product-name').value = '';
    document.getElementById('quantity').value = 1;
    document.getElementById('price').value = '';
}


// // Function to save products to the database
// function saveProducts() {
//     const productsToSave = productsInCart.map(product => ({
//         product_name: product.product_name,
//         quantity: parseInt(product.weight.split(' ')[0]), // Extract quantity from weight
//         total: product.total
//     }));

//     fetch('/save_products', {
//         method: 'POST',
//         headers: {
//             'Content-Type': 'application/json',
//         },
//         body: JSON.stringify({ products: productsToSave }),
//     })
//     .then(response => response.json())
//     .then(data => {
//         if (data.status === 'success') {
//             alert(data.message);
//         } else {
//             alert('Error saving products: ' + data.message);
//         }
//     })
//     .catch(error => {
//         console.error('Error:', error);
//         alert('Error saving products. Please try again.');
//     });
// }

// Function to save a specific product to the database
function saveProduct(product) {
    const productToSave = {
        product_name: product.product_name,
        quantity: parseInt(product.weight.split(' ')[0]), // Extract quantity from weight
        total: product.total
    };

    fetch('/save_products', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ products: [productToSave] }), // Send only the selected product
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            alert(data.message);
        } else {
            alert('Error saving product: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error saving product. Please try again.');
    });
}


// Calculate discount based on offer ID, customer type, and product price
function calculateDiscount(offerId, price) {
    const paymentMode = document.getElementById('paymentMode').value;   
    const customerType = document.getElementById('customer-type').value;
    let discount = 0;

        if (customerTypeDiscounts[customerType]) {
        discount += price * (customerTypeDiscounts[customerType] / 100);
    }

    const currentTime = new Date();
    const currentHour = currentTime.getHours();
    const currentMinute = currentTime.getMinutes();

    switch (offerId) {
        case 'BARGAINBASKET':
            discount += price * 0.05;
            break;
        case 'INSTAMUNCH':
            discount += 15;
            break;
        case 'DIWALIDELIGHTS':
            discount += price * 0.10;
            break;
        case 'PAYTMEXTRA':
            if (paymentMode === 'PAY004') {
                discount += price * 0.05;
            }
            break;
        case 'FLASHFEST':
            if (currentHour === 17 && currentMinute <= 59) {
                discount += price * 0.20;
            }
            break;
        case 'BILLTWEET':
            discount += 30;
            break;
        case 'KHUSIWALIDIWALI':
            if (price > 1000) {
                discount += price * 0.10;
            }
            break;
        case 'WINTERWARMTH':
            discount += price * 0.20;
            break;
        case 'NEWYEARNEWDEAL':
            if (totalBill >= 1500) {
                discount += 200;
            }
            break;
        case 'CASH10':
            if (paymentMode === 'PAY001') {
                discount += price * 0.10;
            }
            break;
        case 'CREDIT5':
            if (paymentMode === 'PAY002') {
                discount += price * 0.05;
            }
            break;
        case 'DEBIT5':
            if (paymentMode === 'PAY003' && totalBill > 2000) {
                discount += price * 0.20;
            }
            break;
        case 'OFF10':
            discount += price * 0.10;
            break;
        default:
            discount += 0;
    }

    return discount;
}

// Refresh product table
function refreshProductTable() {
    const tableBody = document.querySelector('#product-table tbody');
    tableBody.innerHTML = '';
    productsInCart.forEach((product, index) => {
        const row = tableBody.insertRow();
        row.insertCell(0).textContent = product.product_id;
        row.insertCell(1).textContent = product.product_name;
        row.insertCell(2).textContent = product.weight;
        row.insertCell(3).textContent = `₹${product.price.toFixed(2)}`;
        row.insertCell(4).textContent = product.offer_id;
        row.insertCell(5).textContent = product.offer_details;
        row.insertCell(6).textContent = `₹${product.discount.toFixed(2)}`;
        row.insertCell(7).textContent = `₹${product.total.toFixed(2)}`;


        const saveCell = row.insertCell(8);
        const saveButton = document.createElement('button');
        saveButton.textContent = 'Save';
        saveButton.onclick = () => saveProduct(product);
        saveCell.appendChild(saveButton);


        const removeCell = row.insertCell(8);
        const removeButton = document.createElement('button');
        removeButton.textContent = 'Remove';
        removeButton.onclick = () => removeProduct(index);
        removeCell.appendChild(removeButton);
    });
}

// Update the total bill
function updateTotalBill() {
    let total = 0;
    productsInCart.forEach((product) => {
        total += product.total;
    });
    document.getElementById('total-bill').textContent = total.toFixed(2);
    
    // Calculate customer type discount
    const customerType = document.getElementById('customer-type').value;
    let customerDiscountPercentage = 0;
    let customerDiscountAmount = 0;

    if (customerTypeDiscounts[customerType]) {
        customerDiscountPercentage = customerTypeDiscounts[customerType];
        customerDiscountAmount = total * (customerDiscountPercentage / 100);
        document.getElementById('customer-type-discount').textContent = `${customerDiscountPercentage}% discount on your bill as you are a ${customerType}.`;
        document.getElementById('customer-type-discount').style.display = 'block';
    } else {
        document.getElementById('customer-type-discount').style.display = 'none';
    }

    const finalTotal = total - customerDiscountAmount;
    document.getElementById('total-bill').textContent = finalTotal.toFixed(2);
}

// Function to remove product from the cart
function removeProduct(index) {
    productsInCart.splice(index, 1);
    refreshProductTable();
    updateTotalBill();
}

// Function to clear the entire cart
function clearCart() {
    productsInCart = [];
    refreshProductTable();
    updateTotalBill();
}

// Function to generate the bill

// Function to generate the bill
function generateBill() {
    const customerName = document.getElementById('customer-name').value;
    const customerType = document.getElementById('customer-type').value;
    const currentTime = new Date().toLocaleString();

    document.getElementById('receipt-customer-name').innerText = customerName;
    document.getElementById('receipt-customer-type').innerText = customerType;
    document.getElementById('receipt-time').innerText = currentTime;

    const productTable = document.getElementById('product-table').getElementsByTagName('tbody')[0];
    const productRows = productTable.getElementsByTagName('tr');
    const productData = [];
    let totalBill = 0;

    for (let i = 0; i < productRows.length; i++) {
        const cells = productRows[i].getElementsByTagName('td');
        if (cells.length < 8) {
            console.error('Row does not have enough cells:', productRows[i]);
            continue;
        }
        const productName = cells[1].innerText;
        const quantity = parseInt(cells[2].innerText);
        const price = parseFloat(cells[3].innerText.replace(/[^0-9.]/g, ''));
        const offerId = cells[4].innerText;
        const offerDetails = cells[5].innerText;
        const discount = parseFloat(cells[6].innerText.replace(/[^0-9.]/g, ''));
        const total = parseFloat(cells[7].innerText.replace(/[^0-9.]/g, ''));

        if (isNaN(quantity) || isNaN(price) || isNaN(discount) || isNaN(total)) {
            console.error('Error parsing data for:', productName);
            alert('There was an error generating the bill. Please check the input values.');
            return;
        }

        productData.push({ name: productName, quantity: quantity, price: price, offerId: offerId, offerDetails: offerDetails, discount: discount, total: total });
        totalBill += total;
    }

    // Calculate customer type discount for receipt
    let customerTypeDiscount = 0;
    let customerTypeDiscountPercentage = 0;
    if (customerTypeDiscounts[customerType]) {
        customerTypeDiscountPercentage = customerTypeDiscounts[customerType];
        customerTypeDiscount = totalBill * (customerTypeDiscountPercentage / 100);
    }

    // Populate the product table in the receipt modal
    const productTableBody = document.getElementById('receipt-table').getElementsByTagName('tbody')[0];
    productTableBody.innerHTML = '';

    productData.forEach(product => {
        const row = productTableBody.insertRow();
        row.insertCell(0).innerText = product.name;
        row.insertCell(1).innerText = product.quantity;
        row.insertCell(2).innerText = product.price.toFixed(2);
        row.insertCell(3).innerText = product.offerId;
        row.insertCell(4).innerText = product.offerDetails;
        row.insertCell(5).innerText = product.discount.toFixed(2);
        row.insertCell(6).innerText = product.total.toFixed(2);
    });

    // Display total bill and customer type discount
    document.getElementById('receipt-total-bill').innerText = totalBill.toFixed(2);
    // document.getElementById('receipt-customer-type-discount').innerText = `You received a ${customerTypeDiscountPercentage}% discount as you are a ${customerType}.`;
    document.getElementById('receipt-customer-type-discount').style.display = 'block';

    // Show the modal
    document.getElementById('receipt-modal').style.display = 'block';
}

// Close the receipt modal
function closeReceiptModal() {
    document.getElementById('receipt-modal').style.display = 'none';
}

// Print the receipt
function printReceipt() {
    const receiptContent = document.getElementById('receipt-modal').innerHTML;
    document.querySelectorAll('.no-print').forEach(button => {
        button.style.display = 'none';
    });
    window.print();
    document.querySelectorAll('.no-print').forEach(button => {
        button.style.display = 'block';
    });
}

// Download the receipt as PDF
function downloadReceipt() {
    const { jsPDF } = window.jspdf;
    if (!jsPDF) {
        alert("jsPDF library not loaded. Please ensure it is included in your project.");
        return;
    }
    const doc = new jsPDF();
    doc.text('Receipt', 20, 20);
    doc.text('Customer Name: ' + document.getElementById('receipt-customer-name').innerText, 20, 30);
    doc.text('Customer Type: ' + document.getElementById('receipt-customer-type').innerText, 20, 40);
    doc.text('Time: ' + document.getElementById('receipt-time').innerText, 20, 50);

    const productRows = getProductDetailsFromTable();
    let y = 60;
    productRows.forEach(product => {
        const productText = `${product.name} - ${product.quantity} x ₹${product.price.toFixed(2)} (Discount: ₹${product.discount.toFixed(2)}) - Offer Details: ${product.offerDetails} = ₹${product.total.toFixed(2)}`;
        doc.text(productText, 20, y);
        y += 10;
    });

    doc.text('Total Bill: ₹' + document.getElementById('receipt-total-bill').innerText, 20, y + 10);
    // doc.text('You received a discount of ₹' + (parseFloat(document.getElementById('receipt-customer-type-discount').innerText.match(/[\d.]+/)[0]) || 0).toFixed(2) + ' as you are a ' + document.getElementById('receipt-customer-type').innerText, 20, y + 20);

    doc.save('receipt.pdf');
}

// Helper function to get product details from the table
function getProductDetailsFromTable() {
    const productTableBody = document.getElementById('receipt-table').getElementsByTagName('tbody')[0];
    const productRows = productTableBody.getElementsByTagName('tr');
    const productData = [];
    for (let i = 0; i < productRows.length; i++) {
        const cells = productRows[i].getElementsByTagName('td');
        productData.push({
            name: cells[0].innerText,
            quantity: parseInt(cells[1].innerText),
            price: parseFloat(cells[2].innerText),
            discount: parseFloat(cells[5].innerText.replace(/[^0-9.]/g, '')),
            offerDetails: cells[4].innerText,
            total: parseFloat(cells[6].innerText)
        });
    }
    return productData;
}