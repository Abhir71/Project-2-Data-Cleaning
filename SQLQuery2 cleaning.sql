
select *
from [Portfolio 1].dbo.[Nashville housing]


-- Standardize Date fromat

select SaleDateConverted,convert(Date, SaleDate)
from [Portfolio 1].dbo.[Nashville housing]

update [Nashville housing]
set SaleDate = convert(Date, SaleDate)

alter table [Nashville housing]
Add SaleDateConverted date;

update [Nashville housing]
set SaleDateConverted = convert(Date, SaleDate)



--Popular propert Address Data


select *
from [Portfolio 1].dbo.[Nashville housing]
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio 1].dbo.[Nashville housing] a
join [Portfolio 1].dbo.[Nashville housing] b
   on a.ParcelID = b.ParcelID
    and a. [UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio 1].dbo.[Nashville housing] a
join [Portfolio 1].dbo.[Nashville housing] b
   on a.ParcelID = b.ParcelID
   and a. [UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null



-- Breakin Out Address

select PropertyAddress
from [Portfolio 1].dbo.[Nashville housing]


select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 ) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1 , len(PropertyAddress)) as Address

from [Portfolio 1].dbo.[Nashville housing]

alter table [Nashville housing]
Add PropertysplitAddress Nvarchar(255);	

update [Nashville housing]
set PropertysplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 )


alter table [Nashville housing]
Add PropertysplitCity Nvarchar(255);	


update [Nashville housing]
set PropertysplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1 , len(PropertyAddress))

select * from [Portfolio 1].dbo.[Nashville housing]


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio 1].dbo.[Nashville housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio 1].dbo.[Nashville housing]

Update [Portfolio 1].dbo.[Nashville housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


---  Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio 1].dbo.[Nashville housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio 1].dbo.[Nashville housing]


-- Delete Unused Columns

Select *
From [Portfolio 1].dbo.[Nashville housing]


ALTER TABLE [Portfolio 1].dbo.[Nashville housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

