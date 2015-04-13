def boundary_types():
    return ["patch", "wall", "empty", "symmetry"]


def set_boundary_type(patch_dict):
    if patch_dict["type"] == "patch":
        return {
            "type": "patch",
            "nFaces": patch_dict["nFaces"],
            "startFace": patch_dict["startFace"]
        }