{{ config(
    alias='stg_hubspot_email_event_open',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_open_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_open') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_open')),
                staging_columns=get_email_event_open_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        browser,
        duration as duration_open,
        id as event_id,
        ip_address,
        location as geo_location,
        user_agent
    from macro

)

select *
from fields
