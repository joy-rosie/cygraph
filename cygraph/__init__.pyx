"""A graph theory library implemented in Cython.
"""

from .graph cimport Graph, DynamicGraph, StaticGraph


cpdef Graph graph(bint static=False, Graph graph=None, bint directed=False,
        list vertices=[]):
    """Create an instance of a cygraph.Graph object.

    Parameters
    ----------
    static: bint, optional
        Whether to create a cygraph.StaticGraph or cygraph.DynamicGraph
        instance. Setting this to True will mean algorithms will mean
        all operations will run faster, but adding vertices after
        initialization will be slow.
    graph: cygraph.Graph, optional
        A graph to create a copy of.
    directed: bint, optional
        Whether to create a directed graph (otherwise undirected).
    vertices: list, optional
        A list of the vertices in this graph.
    """
    cdef dict kwargs = {
        'graph': graph,
        'directed': directed,
        'vertices': vertices
    }
    if static:
        return StaticGraph(**kwargs)
    else:
        return DynamicGraph(**kwargs)