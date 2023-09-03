/*

Cleaning Data in SQL Queries

*/

-- Reviewed the data to see what needs to be cleaned and understand the dataset.  
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format - did not work; works 80% of the time.

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

-- Standardize Date Format - worked - alternative since previous code did not work.

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date; 

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Select *
From PortfolioProject.dbo.NashvilleHousing

-- dropped column with previous date format to prevent confusion and multiple date columns. 

ALTER TABLE NashvilleHousing
Drop column SaleDate; 

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data for null address records
-- look into the data to identify if there is a relationship between the propertyaddress column and any other columns; i.e. ParcelID is the same where the address is the same.
-- we can use the ParcelID to cross reference with the propertyaddress column because these columns are related.  

Select *
From PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID

-- Performed a self join on the same tables on the parcelid and uniqueid to extract data where property address is null.
-- Performed a self join to link columns together and pull in property addresses that are linked to the parcel ids.
-- ISNULL(NH is null, then use NH2); we are going to insert NH2 address populations into the null address column)

Select NH.ParcelID, NH.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, ISNULL(NH.propertyaddress, NH2.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing NH
JOIN PortfolioProject.dbo.NashvilleHousing NH2
	ON NH.ParcelID = NH2.ParcelID
	AND NH.[UniqueID ] <> NH2.[UniqueID ]
where NH.PropertyAddress is NULL

-- updated NH table, set used to identify which column to update, property address is equal to isnull if NH propertyaddress column is null, then populate NH2 propertyaddress column.  
-- once we ran this query, went back to run previous query above to see if the data had been updated, data was updated because now there are no null/blank values to show.  All addresses are now populated.  

UPDATE NH
SET PropertyAddress = ISNULL(NH.propertyaddress, NH2.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing NH
JOIN PortfolioProject.dbo.NashvilleHousing NH2
	ON NH.ParcelID = NH2.ParcelID
	AND NH.[UniqueID ] <> NH2.[UniqueID ]
where NH.PropertyAddress is NULL
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress 
From PortfolioProject.dbo.NashvilleHousing 

-- SUBSTRING, column name, 1(position 1), character index is searching for a specific value, word or comma, we are searching for a comma below.  After identifying what we are looking for, we tell SQL the column we are looking in; hence, property address after the comma.
-- CHARINDEX -- specifies a position
-- -1 allows us to get rid of the comma because charindex is identified a position #, when we -1 we remove the comma

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

-- Create 2 new columns to hold the 2 address columns from previous query.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))

-- accidentally created the city column before the address column, so I dropped the city column to add the address column first.  

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Drop column PropertySplitCity; 











-- Owner address, city, and state split

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

-- Parse name is useful for delimited; things delimited by a specific value.  Parse name is only useful with periods, it looks for periods. 
-- We replace the commas with periods to enable us to use parsename.
-- Parse name does things backwards, 1 will represent the last part of cell, 2 will represent the middle, and 3 will represent the beginning.  
-- We changed the order of the position #s to get the columns labeled in order.  3,2,1

select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing


-- We will now update our table and add the columns and values from parsing query above.  


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select *
from PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select DISTINCT(SoldAsVacant), COUNT(soldasvacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by count(SoldAsVacant) asc


-- CASE STATEMENT allows us to normalize the data, so we can have one yes or no and not multiple ways of representing the data in one column.  Here we will change all ys and ns to Yes or No and leave all else as is; hence ELSE part of the statement.

select SoldAsVacant
,	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
from PortfolioProject.dbo.NashvilleHousing

-- Once we run the case statement, we have to update the orginal table and set the updated column.  
-- Once we run this query we can go back to the count query and identify if we have a normalized Yes and No form of the data.  
-- YAY!  WE DO :-)
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END

-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns
-- Deleted columns that were not needed because we normalized them in previous queries.  

select *
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress





















