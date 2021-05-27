{{ config(
    alias='stg_hubspot_email_event_deferred',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled','hubspot_email_event_deferred_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event_deferred') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event_deferred')),
                staging_columns=get_email_event_deferred_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        attempt as attempt_number,
        id as event_id,
        response as returned_response
    from macro

)

select *
from fields
