{{ config(
    alias='stg_hubspot_email_event_bounce',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_bounce_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_bounce') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_bounce')),
                staging_columns=get_email_event_bounce_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        category as bounce_category,
        id as event_id,
        response as returned_response,
        status as returned_status
    from macro

)

select *
from fields
