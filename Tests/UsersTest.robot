*** Settings ***
Resource    ../Keywords/Users.robot
Resource    ../Keywords/Utils/Api.robot

*** Test Cases ***
Verify we are able to fetch all users list
    [Tags]  get_users  TC01
    [Teardown]    Close All Active Session
    ${result}    Fetch And Log All Users List
    Log     ${result}

Verify we are able to create user
    [Tags]    create_user    TC02
    [Teardown]    Close All Active Session
    ${result}    Create User    My Dummy User    Software Engineer
    Log     ${result}


Verify we are able to create multiple users from csv
    [Tags]    create_user_from_csv    TC03
    [Teardown]    Close All Active Session
    ${result}    Create Users From Csv    ${USERS_TEST_DATA}
    Log     ${result}




