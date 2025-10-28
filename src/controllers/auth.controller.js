export const getProfile = async (req, res) => {
  try {
    const [users] = await pool.query(
      `
      SELECT u.*, r.name as roleName, r.permissionEdit, reg.nombre as regionName
FROM users u
JOIN roles r ON u.roleId = r.id
JOIN regiones reg ON reg.id = u.id_region
WHERE u.id = ?	
    `,
      [req.user.id],
    )

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    const user = users[0]

    res.status(200).json({
      success: true,
      user: {
        id: user.id,
        email: user.email,
        role: user.roleName,
        permissionEdit: user.permissionEdit === 1,
        regionName: user.regionName // Convert to boolean
      },
    })
  } catch (error) {
    console.error("Get profile error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
}
