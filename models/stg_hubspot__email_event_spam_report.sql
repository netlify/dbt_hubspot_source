{{ config(
    alias='stg_hubspot_email_event_spam_report',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_spam_report_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_spam_report') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_spam_report')),
                staging_columns=get_email_event_spam_report_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        id as event_id,
        ip_address,
        user_agent
    from macro

)

select *
from fields
