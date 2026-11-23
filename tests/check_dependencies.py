import dagster as dg
from orchestration.definitions import defs

graph = defs.get_repository_def().asset_graph

for key in sorted(graph.get_all_asset_keys(), key=str):
    if key.path[0] == "silver":
        parents = graph.get(key).parent_keys
        print(f"{key} <- {sorted(parents, key=str)}")