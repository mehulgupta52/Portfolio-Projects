/*

Cleaning in SQL Queries

*/

-- Changing Date Format

Alter Table NashvilleHousing
Alter column saledate date
Select saledate
from NashvilleHousing

-- Dealing with NULL prop address

select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set a.PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Now, we'll break the address into individual columns of Address, City and State 

Select 
SUBSTRING(propertyaddress, 1,CHARINDEX(',',Propertyaddress)-1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',',Propertyaddress)+1,Len(PropertyAddress)) as City
from NashvilleHousing

Alter Table nashvillehousing
add PropertyCity nvarchar(255)

update NashvilleHousing
set PropertyCity = SUBSTRING(propertyaddress, CHARINDEX(',',Propertyaddress)+1,Len(PropertyAddress))

Update NashvilleHousing
set PropertyAddress = SUBSTRING(propertyaddress, 1,CHARINDEX(',',Propertyaddress)-1) 

-- Doing it for Owner's Address now using parsename

Select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing
where OwnerAddress is not null

Alter Table nashvillehousing
add OwnerAdd nvarchar(255)

update NashvilleHousing
set OwnerAdd = PARSENAME(replace(OwnerAddress,',','.'),3)


Alter Table nashvillehousing
add OwnerCity nvarchar(255)

update NashvilleHousing
set OwnerCity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter Table nashvillehousing
add OwnerState nvarchar(255)

update NashvilleHousing
set OwnerState = PARSENAME(replace(OwnerAddress,',','.'),1)

Select *
from NashvilleHousing


Alter Table nashvillehousing
drop column Owneraddress


-- Changing Y and N to Yes and No in 'Sold as Vacant' field

select SoldAsVacant, count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end as SoldAsVacant_update
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
	 

----------------
-- Removing Duplicate

with row_no 
as(
Select *,
ROW_NUMBER() over(partition by ParcelID,PropertyAddress,SaleDate,
				SalePrice,LegalReference order by uniqueID) row_num
				
from NashvilleHousing
)

Select * 
from row_no
where row_num>1


