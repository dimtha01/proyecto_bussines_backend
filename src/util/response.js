export const createSuccessResponse = (message, data, status = 200) => {
  return {
    success: true,
    message,
    data,
    status
  }
}

export const createErrorResponse = (message, error, status = 500) => {
  return {
    success: false,
    message,
    error,
    status
  }
}