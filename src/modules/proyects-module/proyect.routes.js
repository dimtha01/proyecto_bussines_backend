import { Router } from "express";

const router = Router();

router.get("/", (req, res) => { res.send("proyects Api") });
export default router;