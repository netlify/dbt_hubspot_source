{{ config(
    alias='stg_hubspot_email_event_delivered',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_delivered_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_delivered') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_delivered')),
                staging_columns=get_email_event_delivered_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        id as event_id,
        response as returned_response,
        smtp_id
    from macro

)

select *
from fields
