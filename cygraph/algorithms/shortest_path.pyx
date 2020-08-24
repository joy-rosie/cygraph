"""Functions for finding shortest paths in graphs.
"""

from ..graph cimport Graph, StaticGraph, DynamicGraph


cpdef list find_shortest_path_dijkstra(Graph graph, object source,
        object target):
    """Takes a graph and finds the shortest path between two vertices in
    it using dijkstra's algorithm.

    Parameters
    ----------
    graph: cygraph.Graph
        A graph.
    source
        One of the vertices in `graph`.
    target
        The other vertex in `graph`.

    Returns
    -------
    list
        The list of vertices that constitute the shortest path between
        source and target.
    """
    cdef dict distances, previous_vertices
    cdef set unprocessed_vertices = set()
    # Minimum distance from target to each vertex.
    distances = {}
    # Maps vertices to the vertex that comes before it in the path.
    previous_vertices = {}

    for vertex in graph.vertices:
        distances[vertex] = None
        previous_vertices[vertex] = None
        unprocessed_vertices.add(vertex)
    distances[source] = 0

    cdef object u ,v
    while unprocessed_vertices != set():
        try:
            u = min([v for v in distances
                    if v in unprocessed_vertices and distances[v] is not None])
        except ValueError:
            raise ValueError(f"There is no path in {graph!r} from"
                             f"{source} to {target}")

        unprocessed_vertices.remove(u)
        if u == target:
            break

        for v in graph.get_children(u):
            alternate_distance = distances[u] + graph.get_edge_weight(u, v)
            if ((distances[v] is not None and alternate_distance < distances[v])
                    or distances[v] is None):
                distances[v] = alternate_distance
                previous_vertices[v] = u

    cdef list sequence = []
    u = target
    if previous_vertices[u] is not None or u == source:
        while u is not None:
            sequence.insert(0, u)
            u = previous_vertices[u]

    return sequence