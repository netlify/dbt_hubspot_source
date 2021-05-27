{{ config(
    alias='stg_hubspot_email_campaign',
    enabled=fivetran_utils.enabled_vars(['hubspot_marketing_enabled','hubspot_email_event_enabled'])
) }}

with base as (

    select *
    from {{ var('email_campaign') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('email_campaign')),
                staging_columns=get_email_campaign_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        app_id,
        app_name,
        content_id,
        id as email_campaign_id,
        name as email_campaign_name,
        num_included,
        num_queued,
        sub_type as email_campaign_sub_type,
        subject as email_campaign_subject,
        type as email_campaign_type
    from macro

)

select *
from fields
