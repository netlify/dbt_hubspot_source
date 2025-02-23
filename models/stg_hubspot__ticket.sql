{{ config(
    alias='stg_hubspot_ticket',
    enabled=var('hubspot_service_enabled', False)
) }}

with base as (

    select *
    from {{ var('ticket') }}
    where not coalesce(is_deleted, false)

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('ticket')),
                staging_columns=get_ticket_columns()
            )
        }}
    from base

), fields as (

    select
        id as ticket_id,
        _fivetran_synced,
        is_deleted,
        property_closed_date as closed_at,
        property_createdate as created_at,
        property_first_agent_reply_date as first_agent_reply_at,
        property_hs_pipeline as ticket_pipeline_id,
        property_hs_pipeline_stage as ticket_pipeline_stage_id,
        property_hs_ticket_category as ticket_category,
        property_hs_ticket_priority as ticket_priority,
        property_hubspot_owner_id as owner_id,
        property_subject as ticket_subject,
        property_content as ticket_content

        --The below macro adds the fields defined within your hubspot__ticket_pass_through_columns variable into the staging model
        {{ fivetran_utils.fill_pass_through_columns('hubspot__ticket_pass_through_columns') }}

    from macro

)

select *
from fields
