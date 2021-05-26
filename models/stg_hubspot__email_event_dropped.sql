{{ config(
    alias='stg_hubspot_email_event_dropped',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_dropped_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_dropped') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_dropped')),
                staging_columns=get_email_event_dropped_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        bcc as bcc_emails,
        cc as cc_emails,
        drop_message,
        drop_reason,
        from_email,
        id as event_id,
        reply_to as reply_to_email,
        subject as email_subject
    from macro

)

select *
from fields
