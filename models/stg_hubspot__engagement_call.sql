{{ config(
    alias='stg_hubspot_engagement_call',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_call_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement_call') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement_call')),
                staging_columns=get_engagement_call_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        body as call_notes,
        callee_object_id,
        callee_object_type,
        disposition as disposition_id,
        duration_milliseconds as call_duration_milliseconds,
        engagement_id,
        external_account_id,
        external_id,
        from_number,
        recording_url,
        status as call_status,
        to_number,
        transcription_id,
        unknown_visitor_conversation
    from macro

)

select *
from fields
