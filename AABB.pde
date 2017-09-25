class AABB
{
  PVector min;
  PVector max;
  
  AABB(float bottom, float left)
  {
    min = new PVector(0, 0);
    max = new PVector(left, bottom);
  }
}