{{ config(
    alias='stg_hubspot_email_event',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled'])
) }}

with base as (

    select *
    from {{ var('email_event') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_event')),
                staging_columns=get_email_event_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        app_id,
        caused_by_created as caused_timestamp,
        caused_by_id as caused_by_event_id,
        created as created_timestamp,
        email_campaign_id,
        filtered_event as is_filtered_event,
        id as event_id,
        obsoleted_by_created as obsoleted_timestamp,
        obsoleted_by_id as obsoleted_by_event_id,
        portal_id,
        recipient as recipient_email_address,
        sent_by_created as sent_timestamp,
        sent_by_id as sent_by_event_id,
        type as event_type
    from macro

)

select *
from fields
