/*
Cleaning Data in SQL Queries
*/

Select *
From [Portofolio Project 1]..Housing


-- Standardize Date Format

Select SaleDateConverted, CONVERT(date, SaleDate)
From [Portofolio Project 1]..Housing

Update [Portofolio Project 1]..Housing
SET SaleDate = CONVERT(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Portofolio Project 1]..Housing
Add SaleDateConverted Date;

Update [Portofolio Project 1]..Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From [Portofolio Project 1]..Housing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portofolio Project 1]..Housing a
JOIN [Portofolio Project 1]..Housing b
	On a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portofolio Project 1]..Housing a
JOIN [Portofolio Project 1]..Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portofolio Project 1]..Housing
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From [Portofolio Project 1]..Housing

ALTER TABLE [Portofolio Project 1]..Housing
Add PropertySplitAddress Nvarchar(255);

Update [Portofolio Project 1]..Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [Portofolio Project 1]..Housing
Add PropertySplitCity Nvarchar(255);

Update [Portofolio Project 1]..Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From [Portofolio Project 1]..Housing

Select OwnerAddress
From [Portofolio Project 1]..Housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From [Portofolio Project 1]..Housing

ALTER TABLE [Portofolio Project 1]..Housing
Add OwnerSplitAddress Nvarchar(255);

Update [Portofolio Project 1]..Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [Portofolio Project 1]..Housing
Add OwnerSplitCity Nvarchar(255);

Update [Portofolio Project 1]..Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE [Portofolio Project 1]..Housing
Add OwnerSplitState Nvarchar(255);

Update [Portofolio Project 1]..Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From [Portofolio Project 1]..Housing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portofolio Project 1]..Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From [Portofolio Project 1]..Housing

Update [Portofolio Project 1]..Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						Else SoldAsVacant
						END


-- Remove Duplicates

With RowNumCTE as(
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From [Portofolio Project 1]..Housing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [Portofolio Project 1]..Housing


-- Delete Unused Columns

ALTER TABLE [Portofolio Project 1]..Housing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

Select *
From [Portofolio Project 1]..Housing