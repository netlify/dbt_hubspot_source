{{ config(
    alias='stg_hubspot_ticket_pipeline_stage',
    enabled=var('hubspot_service_enabled', False)
) }}

with base as (

    select *
    from {{ var('ticket_pipeline_stage') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('ticket_pipeline_stage')),
                staging_columns=get_ticket_pipeline_stage_columns()
            )
        }}

    from base
),

final as (

    select
        _fivetran_deleted,
        _fivetran_synced,
        active as is_active,
        display_order,
        is_closed,
        label as pipeline_stage_label,
        cast(pipeline_id as {{ dbt_utils.type_int() }} ) as ticket_pipeline_id,
        cast(stage_id as {{ dbt_utils.type_int() }} ) as ticket_pipeline_stage_id,
        ticket_state
    from fields
    where not coalesce(_fivetran_deleted, false)
)

select *
from final
