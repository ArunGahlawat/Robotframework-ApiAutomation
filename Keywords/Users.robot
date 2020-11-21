*** Settings ***
Library    ../Lib/Helper.py
Resource    Utils/Api.robot
Resource    ../Endpoints/Users.robot


*** Keywords ***
Fetch And Log All Users List
    ${headers}    Create Dictionary    Content-Type=application/json
    ${response}    Send Get Request  ${LIST_USERS}    headers=${headers}
    ${all_users}  Validate And Extract Response Data    ${response}
    ${user_list_length}    Get Length    ${all_users}
    ${output_string}    Format String    {0:20}| {1:20}| {2:50}    First Name    Last Name    Email
    ${output_string}    Format String    ${output_string}${\n}{0:20}| {1:20}| {2:50}    -------------------    -------------------    -------------------------
    FOR    ${user}    IN    @{all_users}
        Log Dictionary     ${user}
        ${user_details}    Format String    {0:20}| {1:20}| {2:50}    ${user}[first_name]    ${user}[last_name]    ${user}[email]
        ${output_string}    Set Variable    ${output_string}${\n}${user_details}
    END
    [Return]    ${output_string}


Create User
    [Arguments]    ${user_name}    ${user_job}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${json}    Create Dictionary    name=${user_name}    job=${user_job}
    ${response}    Send Post Request    ${CREATE_USER}    headers=${headers}    json=${json}
    ${user}    Validate And Extract Response Data    ${response}    201    ${None}
    ${output_string}    Format String    User: '{}' with job: '{}' created successfully on {}    ${user}[name]    ${user}[job]    ${user}[createdAt]
    [Return]    ${output_string}

Create Users From Csv
    [Arguments]  ${csv_data}
    ${csv_data}  Read From Csv As Dict  ${csv_data}
    ${csv_length}  Get Length  ${csv_data}
    ${added_txn}  create dictionary
    ${output_string}    Set Variable    ${EMPTY}
    FOR  ${INDEX}  IN RANGE  ${csv_length}
        ${user_details}  Get From List  ${csv_data}  ${INDEX}
        ${result}    Create User    ${user_details}[user_name]    ${user_details}[user_job]
        ${output_string}    Set Variable    ${output_string}${\n}${result}
    END
    [Return]    ${output_string}
