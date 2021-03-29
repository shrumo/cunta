#define OWL_PARSER_IMPLEMENTATION
#include "face.owl.h"

int main()
{
    struct owl_tree *tree;
    tree = owl_tree_create_from_string(":)");
    owl_tree_print(tree);
    owl_tree_destroy(tree);
    return 0;
}
