-- =============================================================
-- ANÁLISIS DE VENTAS - CHINOOK MUSIC STORE
-- Autora: [tu nombre]
-- Fecha: 12 de mayo de 2026
-- Objetivo: Responder preguntas clave sobre clientes, catálogo 
--           y operación para soporte a decisiones de negocio.
-- Herramientas: SQLite, SQL (JOINs, GROUP BY, agregaciones, funciones de fecha)
-- =============================================================


-- =============================================================
-- PREGUNTA 1: ¿Cuáles son los 10 países que más facturación generan?
-- Métricas: cantidad de clientes únicos, cantidad de facturas, total facturado.
-- =============================================================

SELECT 
    c.Country,
    COUNT(DISTINCT c.CustomerId) AS CantidadClientes,
    COUNT(i.InvoiceId) AS CantidadFacturas,
    ROUND(SUM(i.Total), 2) AS TotalFacturado
FROM Customer AS c
INNER JOIN Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY TotalFacturado DESC
LIMIT 10;


-- =============================================================
-- PREGUNTA 2: ¿Quiénes son los 10 clientes top por gasto total?
-- =============================================================

SELECT 
    c.FirstName,
    c.LastName,
    c.Country,
    COUNT(i.InvoiceId) AS CantidadFacturas,
    ROUND(SUM(i.Total), 2) AS TotalGastado
FROM Customer AS c
INNER JOIN Invoice AS i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
ORDER BY TotalGastado DESC
LIMIT 10;


-- =============================================================
-- PREGUNTA 3: ¿Cuáles son los 5 géneros musicales más vendidos por unidades?
-- =============================================================

SELECT 
    g.Name AS Genero,
    SUM(il.Quantity) AS UnidadesVendidas
FROM Genre AS g
INNER JOIN Track AS t ON g.GenreId = t.GenreId
INNER JOIN InvoiceLine AS il ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY UnidadesVendidas DESC
LIMIT 5;


-- =============================================================
-- PREGUNTA 4: ¿Cuáles son los 10 artistas con mayor facturación?
-- =============================================================

SELECT 
    ar.Name AS Artista,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Facturacion
FROM Artist AS ar
INNER JOIN Album AS al ON ar.ArtistId = al.ArtistId
INNER JOIN Track AS t ON al.AlbumId = t.AlbumId
INNER JOIN InvoiceLine AS il ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId, ar.Name
ORDER BY Facturacion DESC
LIMIT 10;


-- =============================================================
-- PREGUNTA 5: Facturación mensual de la tienda (serie temporal)
-- =============================================================

SELECT 
    strftime('%Y-%m', InvoiceDate) AS Mes,
    ROUND(SUM(Total), 2) AS Facturacion
FROM Invoice
GROUP BY Mes
ORDER BY Mes ASC;