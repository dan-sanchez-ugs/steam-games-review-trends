{{ config(materialized='view') }}

with source as (
    select * from {{ source('staging','steam_data') }}
),

renamed as (
    select
        -- identifiers
        {{ dbt_utils.generate_surrogate_key(['timestamp', 'appid', 'name']) }} as unique_id,
        cast(timestamp as string) as file_timestamp,
        cast(appid as integer) as game_id,
        cast(source.name as string) as game_name,

        -- game info
        cast(price as numeric) as price,
        cast(release_date as string) as release_date,
        cast(dlc_count as integer) as dlc_count,

        -- player info
        cast(estimated_owners as string) as estimated_owners,
        cast(average_playtime_forever as integer) as average_playtime,
        cast(peak_ccu as integer) as peak_concurrent_players,

        -- review info
        cast(num_reviews_total as integer) as total_reviews,
        cast(positive as integer) as positive_reviews,
        cast(negative as integer) as negative_reviews

    from source
    -- Filter out records with null vendor_id (data quality requirement)
    where appid is not null
)

select * from renamed

-- Remove all games that do not have a relevant number of reviews
where total_reviews >= 100

-- Remove any playtests, demos, and betas/alphas
and lower(game_name) not like '%playtest%'
and lower(game_name) not like '%demo%'
and lower(game_name) not like '%beta%'
and lower(game_name) not like '%alpha%'

