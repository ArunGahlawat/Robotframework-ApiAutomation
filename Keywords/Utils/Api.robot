*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Library    curlify
Variables    ../../Config.py

*** Keywords ***

Check For and Create A New Session
    ${is_exists}    Session Exists    MY_SESSION
    Return From Keyword If    ${is_exists}
    Create Session    MY_SESSION    ${HOST}

Close All Active Session
    Delete All Sessions

Process Path Params
    [Arguments]    ${endpoint}    ${path_params}
    ${path_params}    Get Dictionary Keys    ${path_params}
    :FOR    ${path_key}    IN    ${path_params}
    \    ${path_value}    Get From Dictionary    ${path_params}    ${path_key}
    \    ${endpoint}    Replace String    ${endpoint}    {${path_key}}    ${path_value}
    [Return]    ${endpoint}

Validate And Extract Response Data
    [Arguments]    ${response}    ${expected_status_code}=200    ${content_key}=data
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status_code}
    Should Be True    ${response.content} != ${None}
    ${content}    To Json    ${response.content}
    Return From Keyword If    '${content_key}' == '${None}' or '${content_key}' == '${EMPTY}'    ${content}
    Dictionary Should Contain Key    ${content}    ${content_key}
    ${response_date}    Get From Dictionary    ${content}    ${content_key}
    [Return]    ${response_date}

Send Get Request
    [Arguments]    ${endpoint}    ${headers}=${None}    ${query_params}=${None}    ${path_params}=${None}
    ${path_params}    Run Keyword If    ${path_params} != ${None}
    ...    Process Path Params    ${endpoint}    ${path_params}
    Check For And Create A New Session
    ${response}    Get Request    MY_SESSION    ${endpoint}    headers=${headers}    data=${query_params}
    ${curl}    To Curl    ${response.request}
    Log    ${curl}
    [Return]    ${response}

Send Post Request
    [Arguments]    ${endpoint}    ${headers}=${None}    ${query_params}=${None}    ${path_params}=${None}    ${data}=${None}    ${json}=${None}
    ${path_params}    Run Keyword If    ${path_params} != ${None}
    ...    Process Path Params    ${endpoint}    ${path_params}
    Check For And Create A New Session
    ${response}    Post Request    MY_SESSION    ${endpoint}    headers=${headers}    json=${json}    data=${data}    params=${query_params}
    ${curl}    To Curl    ${response.request}
    Log    ${curl}
    [Return]    ${response}