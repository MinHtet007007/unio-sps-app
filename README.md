# To auto generate runner for local database and retrofit

flutter pub run build_runner build --delete-conflicting-outputs


# local 
local form 
- support month data, patient id , township id, receive packages 
receive packages 
        patient_package_id: d.patient_package_id,
        patient_package_name: d.patient_package_name,
        amount: d.amount,
        reimbursement_month: null,
        reimbursement_month_year: null,

# how to store in local 
 - support month data, (remote patient id, local patient id)
 - receive packages (local support month id)

# after sync 

- change sync status of support month 

// home sync 
sync everything and insert all into local database 


