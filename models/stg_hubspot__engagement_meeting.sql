{{ config(
    alias='stg_hubspot_engagement_meeting',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_email_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement_meeting') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement_meeting')),
                staging_columns=get_engagement_meeting_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        body as meeting_notes,
        created_from_link_id,
        end_time as end_timestamp,
        engagement_id,
        external_url,
        meeting_outcome,
        pre_meeting_prospect_reminders,
        source,
        source_id,
        start_time as start_timestamp,
        title as meeting_title,
        web_conference_meeting_id
    from macro

)

select *
from fields
