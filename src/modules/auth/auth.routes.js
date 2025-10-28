import { Router } from "express";
import { getProfile, login , register} from "./auth.controller.js";
import { protect } from "../../middleware/auth.middleware.js";
const router = Router();

router.post("/login", login);

router.post("/register", register);

router.get("/profile", protect, getProfile);


export default router;