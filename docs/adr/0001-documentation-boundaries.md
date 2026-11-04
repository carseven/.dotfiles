# Separate public usage documentation from maintainer records

Public guides and command references live in the Astro content collections and have one authoritative source.
Agent instructions, design interviews, and ADRs stay outside those collections, while blog posts have their own collection.
We chose explicit publication boundaries over rendering all repository Markdown because maintainers and users need different material,
and duplicated guides would require ongoing synchronization. "Internal" means maintainer-oriented, not private: the repository remains public.
