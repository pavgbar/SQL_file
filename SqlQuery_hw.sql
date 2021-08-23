SELECT 
dor.id AS order_id, 
ct.id AS customer_contractor_id, 
ct.title AS contractor, 
st.title AS customer_storage, 
st.id  AS customer_storage_id, 
ct1.id AS supplier_id, 
ct1.title AS supplier, 
st1.id AS supplier_storage_id, 
st1.title AS supplier_storage_title, 
dori.standard_article AS article, 
dori.standard_brand_title AS brand_title, 
doc.document_date AS date_document, 
doc.document_price AS price_document, 
doc.type_of_document AS type_document, 
doc.quantity_in_document AS quantity_in_document 
 
FROM document_order AS dor 
 
JOIN document_order_item AS dori 
ON dor.id = dori.order_id 
 
JOIN contractor AS ct 
ON dor.customer_contractor_id = ct.id 

JOIN contractor AS ct1 
ON dor.supplier_contractor_id = ct1.id 
 
JOIN storage AS st 
ON st.id = dor.customer_storage_id 

JOIN storage AS st1 
ON st1.id = dor.supplier_storage_id 

LEFT JOIN (SELECT 
dsi.order_item_id AS document_id, 
dsi.amount AS document_price, 
dsi.created AS document_date, 
dsi.quantity AS quantity_in_document, 
"shipment" AS type_of_document 

FROM document_shipment_item AS dsi 
 
UNION 
 
SELECT 
dcri.order_item_id AS document_id, 
dcri.amount AS document_price, 
dcri.created AS document_date, 
dcri.quantity AS quantity_in_document, 
"customer_refusal" AS type_of_document 

FROM document_customer_refusal_item AS dcri 

UNION 

SELECT 
dsri.order_item_id AS document_id, 
dsri.amount AS document_price, 
dsri.created AS document_date, 
dsri.quantity AS quantity_in_document, 
"supplier_refusal" AS type_of_document 

FROM document_supplier_refusal_item AS dsri 

UNION 

SELECT 
dori.id AS dociment_id, 
dori.amount AS document_price, 
dori.created AS document_date, 
dori.quantity AS quantity_in_document, 
"order" AS type_of_document 

FROM document_order_item AS dori 
) AS doc 
ON dori.id = doc.document_id 

WHERE YEAR(dor.created) >= 2021 
;