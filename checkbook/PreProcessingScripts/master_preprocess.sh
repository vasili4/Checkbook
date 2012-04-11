#!/bin/sh
echo $1

rm -f goodfile.txt
rm -f badfile.txt
dirName="datafiles/"
if [ $1 == "COAAgency" ] ; then
	fileName=$dirName"COA_agency_feed.txt"
	./removeMalformedAgencyRecords.sh $fileName
	
elif [ $1 == "COABudgetCode" ] ; then
	./removeMalformedBudgetCodeRecords.sh datafiles/COA_budget_code_feed.txt
elif [ $1 == "COADepartment" ] ; then
	fileName=$dirName"COA_department_feed.txt"
	./removeMalformedDepartmentRecords.sh $fileName
	
elif [ $1 == "COAExpenditureObject" ] ; then
	fileName=$dirName"COA_expenditure_object_feed.txt"
	./removeMalformedExpenditureObjectRecords.sh $fileName
	 
elif [ $1 == "COALocation" ] ; then
	fileName=$dirName"COA_location_object_feed.txt"
	./removeMalformedLocationRecords.sh $fileName
	 
elif [ $1 == "COAObjectClass" ] ; then
	fileName=$dirName"COA_object_class_feed.txt"
	./removeMalformedObjectClassRecords.sh $fileName
	 
elif [ $1 == "COARevenueCategory" ] ; then
	fileName=$dirName"COA_revenue_category_feed.txt"
	./removeMalformedRevenueCategoryRecords.sh $fileName
	 
elif [ $1 == "COARevenueClass" ] ; then
	fileName=$dirName"COA_revenue_class_feed.txt"
	./removeMalformedRevenueClassRecords.sh $fileName
	 
elif [ $1 == "COARevenueSource" ] ; then
	fileName=$dirName"COA_revenue_source_feed.txt"
	./removeMalformedRevenueSourceRecords.sh $fileName
	 
elif [ $1 == "CON" ] ; then
	fileName=$dirName"CON_feed.txt"
	./removeMalformedCONRecords.sh $fileName
	 
elif [ $1 == "FMS" ] ; then
	fileName=$dirName"FMS_feed.txt"
	./removeMalformedFMSRecords.sh $fileName
	 
elif [ $1 == "MAG" ] ; then
	fileName=$dirName"MAG_feed.txt"
	./removeMalformedMAGRecords.sh $fileName
	 
elif [ $1 == "Revenue" ] ; then
	fileName=$dirName"Revenue_feed.txt"
	./removeMalformedRevenueRecords.sh $fileName
	 
elif [ $1 == "Budget" ] ; then
	fileName=$dirName"BUDGET_feed.txt"
	./removeMalformedBudgetRecords.sh $fileName
	
fi

if ! [ -f "goodfile.txt" ]; then
        touch "goodfile.txt"
fi

mv goodfile.txt $fileName
if ! [ -f "badfile.txt" ]; then
        touch "badfile.txt"
fi


