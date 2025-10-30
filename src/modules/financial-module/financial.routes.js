import Router from "express";
const router = Router();

router.get("", (req, res) => {
    res.json({ message: "Financial Module" });
});

export default router;