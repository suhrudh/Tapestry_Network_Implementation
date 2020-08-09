# DOS PROJECT 3

# COP5615 – Fall 2019 Distributed Operating System Principles

# PROBLEM DEFINITION
  *The goal of this project is to implement in Elixir using the actor model
the Tapestry Algorithm and a simple object access service to prove its usefulness.*

# REQUIREMENTS
  *Erlang 20.0 or higher*
  *Elixir v1.9*
  *The installation instructions can be found at https://elixir-lang.org/install.html*

#GROUP MEMBERS AND UFID
    *Juhi Gelda : UFID -- 4996-9899*
    *Suhrudh Reddy Sannapareddy : UFID -- 6485-1063*

#STEPS TO RUN THE CODE
    **--> In the terminal, go to <path_to_immediate_directory>/pro3/ **
    **--> Execute => mix run project3.exs <numNodes> <numRequests> in the terminal **
    **--> Output will be the maximum number of hops among all the requests that were made in the network**

#WORKING

Routing Table Creation : Sha-1 was used to generate the hash values for nodes. Further each node's table was updated using prefix-matching, thus updating 8 levels(each consisting 16 columns).

New Node Insertion via Surrogate routing : We implemented new node node insertion via choosing a node from the existing network to find set of nodes whose prefix matches the most with the new node. Thus, updating new node's routing table using the JOIN as described in the PDF.

Hop Calculation : Hop is increased after finding the target node and it's stored in a agent.

Termination : We have introduced 1 insert node operation apart from the numNodes prescribed, maintaining "(numNodes + 5) X numrequests" in a agent, while terminating each search for a particular node it increases the count in this agent.


#LARGEST NETWORK MANAGED TO DEAL WITH
    **Full -- *Nodes 10000 * *Requests 5 *Hops 6 **
