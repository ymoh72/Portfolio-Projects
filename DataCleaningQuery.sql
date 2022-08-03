SELECT * FROM
NashvilleHousingData..Sheet1$

--Standardize Date Format

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM NashvilleHousingData..Sheet1$


UPDATE NashvilleHousingData..Sheet1$
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Sheet1$
ADD SaleDateConverted Date;

UPDATE NashvilleHousingData..Sheet1$
SET SaleDate = CONVERT(Date, SaleDate)


--Populate Property Address data

SELECT *
FROM NashvilleHousingData..Sheet1$
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress
FROM NashvilleHousingData..Sheet1$ a
JOIN NashvilleHousingData..Sheet1$ b
ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousingData..Sheet1$ a
JOIN NashvilleHousingData..Sheet1$ b
 ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

--Breaking out Address into Individual Columns (Address, City, State)

SELECT *
FROM NashvilleHousingData..Sheet1$
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
,	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousingData..Sheet1$

ALTER TABLE NashvilleHousingData..Sheet1$
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousingData..Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousingData..Sheet1$
ADD PropertySplitsCity nvarchar(255);

UPDATE NashvilleHousingData..Sheet1$
SET PropertySplitsCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM NashvilleHousingData..Sheet1$

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousingData..Sheet1$
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousingData..Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousingData..Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingData..Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousingData..Sheet1$
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingData..Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
FROM NashvilleHousingData..Sheet1$


--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousingData..Sheet1$
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' THEN 'Yes'
		ELSE SoldAsVacant
		END
FROM NashvilleHousingData..Sheet1$
 
 UPDATE NashvilleHousingData..Sheet1$
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' THEN 'Yes'
		ELSE SoldAsVacant
		END

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
				
FROM NashvilleHousingData..Sheet1$
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1


--Delete Unused Columns

SELECT *
FROM NashvilleHousingData..Sheet1$

ALTER TABLE NashvilleHousingData..Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDateConverted, PropertySplitCity, OwnerSplitCity